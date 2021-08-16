//
//  RequestProtocol.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/08/16.
//

import Foundation

protocol RequestProtocol {
    associatedtype ResponseType: Decodable
    var baseURL: URL { get }
    var method: HttpMethod { get }
    var path: String { get }
    var header: [String: String] { get }
    var body: Data? { get }
    var queryParameters: [String: String]? { get }
}

extension RequestProtocol {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var header: [String: String] {
        return ["Accept": "application/json"]
    }
    
    var body: Data? {
        return nil
    }
    
    var queryParameters: [String: String]? {
        return nil
    }
}


public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    // etc...
}
