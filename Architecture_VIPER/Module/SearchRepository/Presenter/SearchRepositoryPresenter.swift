//
//  SearchRepositoryPresenter.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/08/16.
//

// Presenterはその画面や機能の仕様書となる、
// Codeが多くなりがちだが、Fatにならないように注意する
// UIView每に作っても良さそう


import Foundation

// View ->  Presenter
// Presenterで実装するもの
protocol SearchRepositoryPresenterInput: AnyObject {
    var numberOfRows: Int { get }
    func viewDidLoad()
    func viewWillAppear()
    func nabigateViewController()
}

// View <- presenter
// Viewに実装されるもの
protocol SearchRepositoryPresenterOutput: AnyObject {
/*
 roadとか
 func showProgressDidLoad()
 func hideProgressDidLoad()
 func showProgressScroll()
 func hideProgressScroll()
 func showData(_ entity: ReadingGoalsResponseEntity)
 func showEmpty()
 func showError()
*/
    
}

final class SearchRepositoryPresenter {
    
    private unowned var view: SearchRepositoryPresenterOutput
    private let router: SearchRepositoryWirefreme
    private let interactor: SearchRepositoryUseCase
    private(set) var datasource: [Repository] = []
    
    init(view: SearchRepositoryPresenterOutput,
         router: SearchRepositoryWirefreme,
         interactor: SearchRepositoryUseCase) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

}


extension SearchRepositoryPresenter: SearchRepositoryPresenterInput {

    var numberOfRows: Int {
        return datasource.count
        
        /*
         Listを表示したい時はここ、
         VCにTableViewだろうが、CollectionViewだろうがなんだろうがList表示をする場合はここでもつ
         VCを知らないようにしたい
         */
    }
    
    // VCのviewDidLoadにセット
    func viewDidLoad() {
        /*
         画面を開いたときに発動したい時こちらを動かす
         今回の場合は画面を開いたらFetchしたいとかならここに書く
         VCは基本的はこれを起動するだけ、
        */
        
        interactor.getSearchRepository(query: "Swift") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                print(success)
                self.datasource.append(contentsOf: success)
            case .failure(let error):
                print(error)
            }
        }
    }
    // VCのviewWillAppearにセット
    func viewWillAppear() {
        /*
         viewDidLoadと考え方は同じだが、
         ページ切り替えで毎回動くのでここはライフサイクルをよく考えて実装する
         */
    }
    
    // ナビゲーションしたい場合こちらに、
    // 複数同線があるならこれを増やす
    func nabigateViewController() {
        router.navigateViewController()
    }
    
    
}
