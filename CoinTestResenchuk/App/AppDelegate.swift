//
//  AppDelegate.swift
//  CoinTestResenchuk
//
//  Created by Roman R. on 3/16/22.
//

import UIKit
import Localize_Swift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window:UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    
}

