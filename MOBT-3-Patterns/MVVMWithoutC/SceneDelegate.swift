//
//  SceneDelegate.swift
//  MVVMWithoutC
//
//  Created by Mykyta Babanin on 01.07.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        self.appCoordinator = AppCoordinator(window: window!)
        appCoordinator?.start()
    }
}

