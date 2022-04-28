//
//  RequestManager.swift
//  RickAndMorty
//
//  Created by Sharun Garg on 2022-04-23.
//

import Foundation

fileprivate enum HTTPRequestError: Error {
    case badData
    case badResponse
    case invalidURL
}

class RequestManager {
    static let shared: RequestManager = RequestManager()
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        self.session = URLSession(configuration: configuration)
    }
    
    func request<T: Codable>(with url: URL?, forData toDataType: T.Type, completion: @escaping (Result<T, Error>)->()) {
        guard let validURL = url else {
            completion(.failure(HTTPRequestError.invalidURL))
            return
        }
        
        let task = self.session.dataTask(with: validURL) { (data, response, error) in
            guard let validData = data else {
                if let error = error {
                    completion(.failure(error))
                }
                completion(.failure(HTTPRequestError.badData))
                return
            }
            
            guard let requestResponse = response as? HTTPURLResponse, (200...299).contains(requestResponse.statusCode) else {
                completion(.failure(HTTPRequestError.badResponse))
                return
            }
            
            if let data = validData as? T {
                completion(.success(data))
                return
            }
            
            do {
                let data = try JSONDecoder().decode(toDataType, from: validData)
                completion(.success(data))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
