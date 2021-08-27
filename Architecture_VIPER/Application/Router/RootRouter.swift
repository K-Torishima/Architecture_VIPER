//
//  RootRouter.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/08/27.
//

import UIKit

protocol AppWireframe: AnyObject {
    func navigateViewController()
}

final class AppRouter {
    
    private let window: UIWindow
    
    private init(window: UIWindow) {
        self.window = window
    }
    
    static func assembleModules(window: UIWindow) -> AppPresentation {
        let router = AppRouter(window: window)
        let presenter = AppPresenter(router: router)
        
        return presenter
    }
}

extension AppRouter: AppWireframe {
    func navigateViewController() {
        // 最初の画面をDI
        let view = SearchRepositoryRouter.assembleModule()
        let navigationController = UINavigationController(rootViewController: view)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
