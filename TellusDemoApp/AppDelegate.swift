//
//  AppDelegate.swift
//  TellusDemoApp
//
//  Created by GGTECH LLC on 4/14/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { self.window = UIWindow(frame: UIScreen.main.bounds)
        
        checkIfLoggedIn()
        
        return true
    }
    
    
    func checkIfLoggedIn(){
        if !SessionManager.shared.isLogin() {
            DispatchQueue.main.async {
                let signUpVC = SignupViewController()
                self.window?.rootViewController = signUpVC
                self.window!.makeKeyAndVisible()
            }
        } else {
            let controller = HomeViewController()
            let homeController = UINavigationController(rootViewController: controller)
            window?.rootViewController = homeController
            window?.makeKeyAndVisible()
            
        }
        
    }
}

