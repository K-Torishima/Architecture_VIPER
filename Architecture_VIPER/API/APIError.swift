//
//  APIError.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/08/16.
//

import Foundation

enum APIError: Error {
    case noData(HTTPURLResponse)
    case noResponse
    case unacceptableStatusCode(Int, Message?)
    case failedToCreateComponents(URL)
    case failedToCreateURL(URLComponents)
}

extension APIError {
    struct Message: Decodable {
        public let documentationURL: URL
        public let message: String

        enum CodingKeys: String, CodingKey {
            case documentationURL = "documentation_url"
            case message
        }
    }
}
