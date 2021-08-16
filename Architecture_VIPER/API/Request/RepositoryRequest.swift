//
//  RepositoryRequest.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/08/16.
//

import Foundation
 


struct RepositoryRequest: RequestProtocol {
    typealias ResponseType = Repository
    
    let method: HttpMethod = .get
    
    var path: String {
        return "/users/\(username)/\(repositoryName)"
    }

    let username: String
    let repositoryName: String

    init(username: String, repositoryName: String) {
        self.username = username
        self.repositoryName = repositoryName
    }
}
