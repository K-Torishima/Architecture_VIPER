# Architecture_VIPER
## VIPERを勉強していくためのモチベーションに関して

### これを実装してみたモチベーション
- RxやCombineなどのReactive frameworkを使わないで、それなりに責務を分けてわかりやすい実装をしたいと思ったので実際にやってみた

### やってみた感想

- シンプルかつ、責務がある程度切り分けられていて良い。
- またそれなりに変更に強いと思う
- 登場人物が多いので、ファイル数が多くなるが、大、中規模アプリを作る予定なら、VIPERならわかりやすくて良いのではないかと感じた。
- Rxや、Combineを使うなら、VIPERではなく、CleanArchitecture + MVVM　＋　Router　でもよさそう
- 参考　https://medium.com/@rockname/clean-archirecture-7be37f34c943

### 実際に取り入れるなら

例えば、エンジニアが３人いたとして、
新規アプリ作る場合、シンプルにVIPERなら実装するレイヤーが切り分けられる、

- APIクライアント実装, Entity実装
- UseCase, Interactor実装, presenter実装　　(機能の振る舞いなど） 　
- view,　(ViewController, View, Cell, その他UI）, Routerの実装　（画面遷移、DIコンテナ等）　　

３人いたらある程度のスピード感で実装ができそう

## 本題（メモも含む）
### VIPERって何？
ちょーざっくり言うとクリーンアーキテクチャーのiOS版

![スクリーンショット 2021-08-11 18 58 16](https://user-images.githubusercontent.com/52149750/129009833-438b88d8-96f2-47ba-a15f-2a2cd166cbe4.png)

![スクリーンショット 2021-08-11 18 58 46](https://user-images.githubusercontent.com/52149750/129009886-1b9501ec-83ad-46bb-9aff-b5d035ac7d31.png)


### 関連資料
- https://dev.classmethod.jp/articles/developers-io-2020-viper-architecture/
- https://dev.classmethod.jp/articles/developers-io-2020-viper-architecture-comment-res-2/
- https://www.yururiwork.net/archives/347
- https://github.com/yimajo/VIPERBook1Samples/blob/master/Sample1A/Common/Protocol/UseCase.swift
- https://qiita.com/hicka04/items/09534b5daffec33b2bec
- https://qiita.com/hirothings/items/8ce3ca69efca03bbef88

--------------------------------------------

## View間の操作に関してのサンプル

- 参考記事
- https://qiita.com/fr0g_fr0g/items/f6e67793c7fb0331528f
- これ以外にもやり方はある

### 遷移先の画面から遷移元にアクションを伝える場合

#### 動き

- APIを叩いてsuccessなら、遷移元のViewを更新したい

#### 遷移先　Presenter
``` swift 

protocol HogePresenterDelegate: AnyObject {
    func update()
}

protocol HogePresenterInput: AnyObject {
 // ...
}

protocol HogePresenterOutput: AnyObject {
 // ...
}

final class HogePresenter {
    private unowned var view: HogePresenterOutput
    private let router: HogeWirefreme
    private let interactor: HogeUseCase

    private weak var delegate: HogePresenterDelegate?

    init(view: HogePresenterOutput,
         router: HogeWirefreme,
         interactor: HogeUseCase,
         delegate: HogePresenterDelegate) {
        self.view = view
        self.router = router
        self.interactor = interactor
        self.delegate = delegate

    }
}

```

#### delegate実装

``` swift

func post() {
        self.view.showProgress()
        let request = RepuestEntity()
        interactor.postSetting(requestEntity: request) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.update()
            self.popTo()
        } failed: { [weak self] error in
            guard let self = self else { return }
            self.view.hideProgress()
            print(error as Any)
        }
    }

``` 

#### 遷移先　Router

``` swift

protocol HogeWirefreme {
// impl
}

final class HogeRouter: HogeWirefreme {
    private unowned let viewController: UIViewController

    private init(viewController: UIViewController) {
        self.viewController = viewController
    }

    static func assembleModule(_ delegate: HogePresenterDelegate) -> UIViewController {
        let view = HogeViewController()
        let router = HogeRouter(viewController: view)
        let interactor = HogeInteractor()
        let presenter = HogePresenter(view: view, router: router, interactor: interactor, delegate: delegate)
        view.presenter = presenter
        return view
    }

```

#### 遷移元 Router

``` swift

protocol FugaWirefreme {
    func navigateViewController(delegate: HogePresenterDelegate)
}

class FugaRouter: FugaWirefreme {
    private unowned let viewController: UIViewController

    private init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // DI
    static func assembleModule() -> UIViewController {
　 // impl  遷移対象のRouterが生成する
    }

    // ここでdelegateをセット
    func navigateViewController(delegate: HogePresenterDelegate) {
        let view = HogeRouter.assembleModule(delegate)
        viewController.navigationController?.pushViewController(view, animated: true)
    }
}

```

#### 遷移元　Presenter 

``` swift

class FugaPresenter {
    // init() 
 
　// presenterでdeleagteをself
    func navigateViewController() {
        router.navigateViewController(delegate: self)
    }
}

```

#### delegate実装

``` swift 

// HogePresenterDelegateのupdate()methodの実装
extension FugaPresenter: HogePresenterDelegate {
    func update() {
        reset()
        featchData { [weak self] in
            guard let self = self else { return }
            self.view.hideProgressDidLoad()
        } failed: { [weak self] in
            guard let self = self else { return }
            self.view.showError()
        }
    }
}

```

#### 流れ
```
HogeViewで何かしらのアクションがあった
-> HogePresenter で　delegate.update（）を読んでいる
-> HogeRouter でDIを定義
-> FugaRouter でNavigation時にDI
-> FugaPresenter でdelegateをselfし、実装する（Viewに何かしらの渡すものがあればその時に渡す）
-> FugaViewでイベントが発火される 

```


--- 

## Concurrency対応した 2022/5/18

### interactor　<- Presenter

APIクライアントをConcurrency対応
肝は`withCheckedThrowingContinuation`
Result型でError型を返さなくなったのでErrorをどうするのかとかアレだったが
continuation.resume(throwing:)で対応

continuationには `resume(returning:)` もある、これは`success`
`resume(throwing:)` 　は`failure`




``` swift

func request<T: RequestProtocol>(_ request: T) async throws -> T.ResponseType {
        return try await withCheckedThrowingContinuation { continuation in
            let url = request.baseURL.appendingPathComponent(request.path)
            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                continuation.resume(throwing: APIError.failedToCreateComponents(url))
                return
            }
            
            ...... 
        
            let task = session.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    continuation.resume(throwing: APIError.noResponse)
                    return
                }
                guard let data = data else {
                    continuation.resume(throwing: APIError.noData(response))
                    return
                }
                
                ....... 
               
                do {
                    let object = try JSONDecoder().decode(T.ResponseType.self, from: data)
                    continuation.resume(returning: object)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
            task.resume()
        }
    }
}
```


### UseCaseはかなりシンプルになる


``` swift 

protocol SearchRepositoryUseCase {
    /// collback
    func getSearchRepository(query: String, conpletion: @escaping (Result<[Repository], Error>) -> ())
    /// async
    func getSearchRepository(query: String) async throws -> [Repository]
}

class SearchRepositoryInteractor: SearchRepositoryUseCase {
    let session = APIClient()
    
    /// collback
    func getSearchRepository(query: String, conpletion: @escaping (Result<[Repository], Error>) -> ()) {
        let request = SearchRepositoriesRequest(query: query, sort: nil, order: nil, page: nil, perPage: nil)
        session.request(request) { result in
            switch result {
            case.success(let response):
                conpletion(.success(response.items))
            case .failure(let error):
                conpletion(.failure(error))
            }
        }
    }
    
    /// async 
    func getSearchRepository(query: String) async throws -> [Repository] {
        let request = SearchRepositoriesRequest(query: query, sort: nil, order: nil, page: nil, perPage: nil)
        let response = try await session.request(request)
        return response.items
    }
}



``` 

### Presenter
呼ぶ側はもっとシンプル
[weak self]からの解放

@MainActorは必須

``` swift

@MainActor
final class SearchRepositoryPresenter {


func viewDidLoad() {
    view.showProgressDidLoad()
    asyncFetchData()
}

....

    private func asyncFetchData() {
        Task {
            do {
                defer { Task {@MainActor in view.hideProgressDidLoad }}
                let response = try await interactor.getSearchRepository(query: "Go")
                datasource.append(contentsOf: response)
                view.showData()
            } catch let error {
                print(error)
            }
        }
    }
}


```
