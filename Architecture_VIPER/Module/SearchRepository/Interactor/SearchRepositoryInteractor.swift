//
//  SearchRepositoryInteractor.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/08/16.
//

import Foundation

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
