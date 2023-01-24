import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        if !UserDefaults.standard.bool(forKey: "isNotFirstOpen") {
            _ = AccountService.instance.tryDeposit(50000)
            UserDefaults.standard.set(true, forKey: "isNotFirstOpen")
        }
        let navigationViewController = UINavigationController(rootViewController: MainViewController())
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
    }

}
