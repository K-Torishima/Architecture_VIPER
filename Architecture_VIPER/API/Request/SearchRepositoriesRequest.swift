//
//  SearchRepositoriesRequest.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/08/16.
//

import Foundation

public struct SearchRepositoriesRequest: RequestProtocol {    
    typealias ResponseType = ItemsResponse<Repository>

    public let method: HttpMethod = .get
    public let path = "/search/repositories"

    public var queryParameters: [String : String]? {
        var params: [String: String] = ["q": query]
        if let page = page {
            params["page"] = "\(page)"
        }
        if let perPage = perPage {
            params["per_page"] = "\(perPage)"
        }
        if let sort = sort {
            params["sort"] = sort.rawValue
        }
        if let order = order {
            params["order"] = order.rawValue
        }
        return params
    }

    public let query: String
    public let sort: Sort?
    public let order: Order?
    public let page: Int?
    public let perPage: Int?

    public init(query: String, sort: Sort?, order: Order?, page: Int?, perPage: Int?) {
        self.query = query
        self.sort = sort
        self.order = order
        self.page = page
        self.perPage = perPage
    }
}

extension SearchRepositoriesRequest {
    public enum Sort: String {
        case stars
        case forks
        case updated
    }

    public enum Order: String {
        case asc
        case desc
    }
}
