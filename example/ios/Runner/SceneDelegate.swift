import UIKit
import Flutter
import MediaPlayer

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.window?.insertSubview(MPVolumeView(), at: 0)
    }
}
