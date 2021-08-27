//
//  AppPresenter.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/08/27.
//

import Foundation

protocol AppPresentation: AnyObject {
    func didFinishLaunch()
}

final class AppPresenter {
    private let router: AppWireframe
    
    init(router: AppWireframe) {
        self.router = router
    }
}

extension AppPresenter: AppPresentation {
    func didFinishLaunch() {
        router.navigateViewController()
    }
}
