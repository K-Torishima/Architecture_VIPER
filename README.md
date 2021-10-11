# Architecture_VIPER
## VIPERを勉強していくためのモチベーションに関して、
シンプルかつ、責務がある程度切り分けられていて良い。
またそれなりに変更に強いと思う


工数を考えるとちょっと多いがこれがある程度決まったレイヤーを実装していく場合これが良いのではないかと感じた。

Repository+MVVM＋Router　でもよさそう

例えば、エンジニアが３人いたとして、
新規アプリ作る場合、シンプルにVIPERなら実装するレイヤーが切り分けられる、

- APIクライアント実装、Model、Entity実装、　
- UseCase、Interactor実装、　presenter実装 　
- view,　(ViewController、他UIの実装）　、Routerの実装

３人いたらある程度のスピード感で実装ができそう

## VIPERって何？
ちょーざっくり言うとクリーンアーキテクチャーのiOS版

![スクリーンショット 2021-08-11 18 58 16](https://user-images.githubusercontent.com/52149750/129009833-438b88d8-96f2-47ba-a15f-2a2cd166cbe4.png)

![スクリーンショット 2021-08-11 18 58 46](https://user-images.githubusercontent.com/52149750/129009886-1b9501ec-83ad-46bb-9aff-b5d035ac7d31.png)


関連資料
https://dev.classmethod.jp/articles/developers-io-2020-viper-architecture/
https://dev.classmethod.jp/articles/developers-io-2020-viper-architecture-comment-res-2/
https://www.yururiwork.net/archives/347
https://github.com/yimajo/VIPERBook1Samples/blob/master/Sample1A/Common/Protocol/UseCase.swift
https://qiita.com/hicka04/items/09534b5daffec33b2bec
https://qiita.com/hirothings/items/8ce3ca69efca03bbef88

--------------------------------------------

## View間の操作に関してのサンプル

Presenterを土台とし、PresenterでDelegateをセットする
参考記事はこれ、

https://qiita.com/fr0g_fr0g/items/f6e67793c7fb0331528f
これが結構スッキリ来るのではなか、

## 遷移先の画面から遷移元にアクションを伝える場合

### 動き

- APIを叩いてサクセスなら、遷移元のViewを更新したい

### 遷移先　Presenter
``` swift 

protocol HogePresenterDelegate: AnyObject {
    func update()
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

### delegate実装

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

### 遷移先　Router

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

### 遷移元 Router

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

### 遷移元　Presenter 

``` swift

class FugaPresenter {
    // init() 
 
　// presenterでdeleagteをself
    func navigateViewController() {
        router.navigateViewController(delegate: self)
    }
}

```

### delegate実装

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

### 流れ

HogeViewで何かしらのアクションがあった
-> HogePresenter で　delegate.update（）を読んでいる
-> HogeRouter でDIを定義
-> FugaRouter でNavigation時にDI
-> FugaPresenter でdelegateをselfし、実装する（Viewに何かしらの渡すものがあればその時に渡す）
-> FugaViewでイベントが発火される 

