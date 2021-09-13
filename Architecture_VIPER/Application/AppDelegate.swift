//
//  AppDelegate.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/08/16.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let appPresenter = AppRouter.assembleModules(window: UIWindow(frame: UIScreen.main.bounds))


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        appPresenter.didFinishLaunch()
        // Override point for customization after application launch.
        return true
    }
}

