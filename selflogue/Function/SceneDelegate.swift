import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // MARK: - UISceneDelegate Methods
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Called when the app is about to connect to a new scene.
        // Perform necessary setup for the scene here.
        // In this implementation, it checks if the scene is an instance of UIWindowScene.
        // If not, the method returns early.
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called when the scene is disconnected.
        // Add any cleanup code or post-disconnection logic here.
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene becomes active.
        // Perform any tasks that need to be done when the app becomes active here.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will resign its active state.
        // Perform any tasks that need to be done when the app is about to become inactive here.
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called when the scene is about to enter the foreground.
        // Perform any tasks that need to be done when the app is about to enter the foreground here.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called when the scene enters the background.
        // Perform any tasks that need to be done when the app enters the background here.
    }
}

