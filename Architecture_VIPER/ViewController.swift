//
//  ViewController.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/08/16.
//

import UIKit

class ViewController: UIViewController {
    
    let interactor: SearchRepositoryInteractor = SearchRepositoryInteractor()

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.getSearchRepository(query: "torishima") { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}

