//
//  APIClient.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/08/16.
//

import Foundation

class APIClient {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    @discardableResult
    func request<T: RequestProtocol>(_ request: T,
                                     completion: @escaping (Result<T.ResponseType, Error>) -> ()) -> URLSessionTask? {
        
        
        let url = request.baseURL.appendingPathComponent(request.path)
        
        guard var componets = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(APIError.failedToCreateComponents(url)))
            return nil
        }
        
        componets.queryItems = request.queryParameters?.compactMap(URLQueryItem.init)
        
        guard var urlRequest = componets.url.map({ URLRequest(url: $0) }) else {
            completion(.failure(APIError.failedToCreateURL(componets)))
            return nil
        }
        
        urlRequest.httpMethod = request.method.rawValue
        
        if let body = request.body {
            urlRequest.httpBody = body
        }
        
        urlRequest.allHTTPHeaderFields = request.header
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(APIError.noResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData(response)))
                return
            }
            
            guard  200..<300 ~= response.statusCode else {
                let message = try? JSONDecoder().decode(APIError.Message.self, from: data)
                completion(.failure(APIError.unacceptableStatusCode(response.statusCode, message)))
                return
            }
            
            do {
                let object = try JSONDecoder().decode(T.ResponseType.self, from: data)
                completion(.success((object)))
                
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        return task
    }
}
