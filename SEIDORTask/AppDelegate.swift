//
//  AppDelegate.swift
//  SEIDORTask
//
//  Created by Sundhar on 06/07/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController: UIViewController
        
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            // User is logged in, set CharacterListVC as root
            let characterListVC = mainStoryboard.instantiateViewController(withIdentifier: "CharacterListVC") as! CharacterListVC
            initialViewController = characterListVC
        } else {
            // User is not logged in, set LoginVC as root
            let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            initialViewController = loginVC
        }
        
        let navigationController = UINavigationController(rootViewController: initialViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }


    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

