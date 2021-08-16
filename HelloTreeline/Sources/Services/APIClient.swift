//
//  APIClient.swift
//  HelloTreeline
//
//  Copyright © 2021 Treeline. All rights reserved.
//

import Foundation

enum APIClientError: Error {
    case unknown(internalError: Error?)
    case decodingError
}

protocol APIClient {
    func get<T: Decodable>(endpoint: String, type: T.Type, completion: @escaping (Result<T, APIClientError>) -> Void)
}

class DefaultAPIClient: APIClient {
    
    static let shared: APIClient = DefaultAPIClient(baseURL: Constants.baseURL)
    
    private let urlSession = URLSession.shared
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func get<T>(endpoint: String, type: T.Type, completion: @escaping (Result<T, APIClientError>) -> Void) where T : Decodable {
        var request = URLRequest(url: baseURL.appendingPathComponent(endpoint))
        request.httpMethod = "GET"
        urlSession.dataTask(with: request) { data, response, error in
            if let data = data, error == nil {
                if let dataString = String(data: data, encoding: .utf8) {
                    print("\(#function) \(dataString)")
                }
                do {
                    let decoded = try JSONDecoder().decode(type, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(.decodingError))
                }
            } else {
                completion(.failure(.unknown(internalError: error)))
            }
        }.resume()
    }
}
