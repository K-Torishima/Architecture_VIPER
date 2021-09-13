//
//  SearchRepositoryRouter.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/08/16.
//

import UIKit

// Ruterは主に画面遷移をする
// https://qiita.com/hicka04/items/09534b5daffec33b2bec

protocol SearchRepositoryWirefreme {
    func navigateViewController()
}

class SearchRepositoryRouter: SearchRepositoryWirefreme {
    
    private unowned let viewController: UIViewController

    private init(viewcontroller: UIViewController) {
        self.viewController = viewcontroller
    }
    
    // DI
    static func assembleModule() -> UIViewController {
        // Storyboardを使う場合はStoryboardを生成する
        // DIするならこの辺ちゃんと考えた方が良い
        let storyboard = UIStoryboard(name: "SearchRepository", bundle: nil)
        let view = storyboard.instantiateViewController(identifier: "searchRepository") as! SearchRepositoryViewController
        let router = SearchRepositoryRouter(viewcontroller: view)
        let interactor = SearchRepositoryInteractor()

        let presenter = SearchRepositoryPresenter(view: view,
                                                  router: router,
                                                  interactor: interactor)
        view.presenter = presenter
        return view
    }

    func navigateViewController() {
        // present
        // let view = hogeassembleModule()
        // UINavigationController.pushViewController(view)
    }
}
