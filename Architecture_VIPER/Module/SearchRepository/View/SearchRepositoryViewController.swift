//
//  SearchRepositoryViewController.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/08/16.
//

import UIKit

// ViewControllerはUIのことしかしない
// 基本的には、Presenterからの指示を受ける

class SearchRepositoryViewController: UIViewController {
    
    var presenter: SearchRepositoryPresenterInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension SearchRepositoryViewController : SearchRepositoryPresenterOutput {
    
}
