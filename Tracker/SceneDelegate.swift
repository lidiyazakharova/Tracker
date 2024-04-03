import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
//        self.window?.rootViewController = TabBarController()
//        self.window?.makeKeyAndVisible()
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.onboardingCompletionHandler = { [weak self] in
            let tabBarController = TabBarController()
            self?.window?.rootViewController = tabBarController
        }
        window?.rootViewController = onboardingViewController
        window?.makeKeyAndVisible()
    }

}

