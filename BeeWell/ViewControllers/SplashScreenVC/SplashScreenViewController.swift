//
//  SplashScreenViewController.swift
//  BeeWell
//
//  Created by Furkan Doğan on 15.12.2024.
//

import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.transitionToMainApp()
        })
    }

    
    private func transitionToMainApp() {
        guard let scene = view.window?.windowScene else {
            print("No active UIWindowScene found.")
            return
        }
        if let window = scene.windows.first {
            let transition = CATransition()
            transition.type = .fade
            transition.duration = 0.3
            window.layer.add(transition, forKey: kCATransition)
            let tabBarController = MainTabBarController()
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }
}
