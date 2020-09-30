//
//  SceneDelegate.swift
//  CharactersGrid
//
//  Created by Alfian Losari on 9/22/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let rootVC = UINavigationController(rootViewController: UIViewController())
        
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        self.window = window
    }

}

