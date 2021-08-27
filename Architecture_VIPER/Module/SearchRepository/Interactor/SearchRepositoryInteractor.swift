//
//  SearchRepositoryInteractor.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/08/16.
//

import Foundation

// ビジネスロジックを担当する
// Presenterから依頼されたビジネスロジックを実施し、結果を返す
// import UIKit 禁止
// UIがどうなっているかはここでは関係ない
// Interactor <- Presenter

// UseCaseは別途UseCaseProtocolを実装し対応させる、最終的にはこちらに寄せていく

// https://github.com/yimajo/VIPERBook1Samples/blob/master/Sample1A/Common/Protocol/UseCase.swift

protocol SearchRepositoryUseCase {
    func getSearchRepository(query: String, conpletion: @escaping (Result<[Repository], Error>) -> ())
}

class SearchRepositoryInteractor: SearchRepositoryUseCase {
    func getSearchRepository(query: String, conpletion: @escaping (Result<[Repository], Error>) -> ()) {
        let session = APIClient()
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
}
