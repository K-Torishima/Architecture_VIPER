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
    // var hasNext: Bool { get set }
    func viewDidLoad()
    func viewWillAppear()
    func getRepository(forRow row: Int) -> Repository
    // func needMoreRead(_ row: Int) -> Bool
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
    func showProgressDidLoad()
    func hideProgressDidLoad()
    func showData()
    
}

final class SearchRepositoryPresenter {
    
    private unowned var view: SearchRepositoryPresenterOutput
    private let router: SearchRepositoryWirefreme
    private let interactor: SearchRepositoryUseCase
    private(set) var datasource: [Repository] = []
    var hasNext: Bool = false
    
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
    
    func getRepository(forRow row: Int) -> Repository {
        return datasource[row]
    }
    
    // GitHubの場合、Pageのカウントを渡す。
    // HasNextはいらない
    // func needMoreRead(_ row: Int) -> Bool {
       //  return hasNext && row == datasource.count + 1
    // }
    // VCのviewDidLoadにセット
    func viewDidLoad() {
        /*
         画面を開いたときに発動したい時こちらを動かす
         今回の場合は画面を開いたらFetchしたいとかならここに書く
         VCは基本的はこれを起動するだけ、
        */
        
        // pageを指定してあげる
        // pre_pageは10とかで良いと思う
        // 次のpageが欲しかったらインクリメントする
        view.showProgressDidLoad()
        interactor.getSearchRepository(query: "Swift") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.datasource.append(contentsOf: response)
                DispatchQueue.main.async {
                    self.view.showData()
                }
            case .failure(let error):
                print(error)
            }
        }
        view.hideProgressDidLoad()
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
