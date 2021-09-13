# Architecture_VIPER
## VIPERを勉強していくためのモチベーションに関して、
シンプルかつ、責務がある程度切り分けられていて良い。
またそれなりに変更に強いと思う


工数を考えるとちょっと多いがこれがある程度決まったレイヤーを実装していく場合これが良いのではないかと感じた。

Repository+MVVM＋R　でもよさそう

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
