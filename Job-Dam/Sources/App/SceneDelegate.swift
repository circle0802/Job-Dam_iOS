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
        
        // 초기 화면 설정
        setupInitialViewController()
        
        window?.makeKeyAndVisible()
    }
    
    private func setupInitialViewController() {
        let isLoggedIn = Token.accessToken != nil
        
        if isLoggedIn {
            showMainTabbar()
        } else {
            showLoginScreen()
        }
    }
    
    private func showLoginScreen() {
        let loginVC = LoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        window?.rootViewController = nav
    }
    
    private func showMainTabbar() {
        window?.rootViewController = TabbarViewController()
    }
    
    // MARK: - Static Methods for Root Controller Switching

    // MARK: - Static Methods for Root Controller Switching (No Animation)

    static func switchToMainTabbar() {
        guard let window = getCurrentWindow() else { return }
        window.rootViewController = TabbarViewController()
    }

    static func switchToLoginScreen() {
        guard let window = getCurrentWindow() else { return }
        let loginVC = LoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        window.rootViewController = nav
    }

    /// 현재 윈도우를 가져오는 헬퍼 메소드
    private static func getCurrentWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
