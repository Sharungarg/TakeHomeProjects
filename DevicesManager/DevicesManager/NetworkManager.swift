//
//  NetworkManager.swift
//  DevicesManager
//
//  Created by Sharun Garg on 2022-04-25.
//

import Foundation

enum HTTPRequestErrors: Error {
    case BadData
    case BadRequestResponse
    case BadDecoding
}

final class RequestManager {
    static let shared = RequestManager()
    let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        self.session = URLSession(configuration: config)
    }
    
    func request<T: Codable>(url: URL?, forData toDataType: T.Type, completion: @escaping (Result<T, Error>)->()) {
        guard let url = url else {
            do {
                let dataObject = try JSONDecoder().decode(toDataType, from: dummyData)
                completion(.success(dataObject))
            } catch let error {
                completion(.failure(error))
            }
            return
        }
        
        RequestManager.shared.session.dataTask(with: url) { (data, responseType, error) in
            guard let validData = data else {
                if let error = error {
                    completion(.failure(error))
                }
                completion(.failure(HTTPRequestErrors.BadData))
                return
            }
            
            guard let requestResponse = responseType as? HTTPURLResponse, (200...299).contains(requestResponse.statusCode) else {
                completion(.failure(HTTPRequestErrors.BadRequestResponse))
                return
            }
            
            do {
                let dataObject = try JSONDecoder().decode(toDataType, from: validData)
                completion(.success(dataObject))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
}

fileprivate let dummyData = """
{
    "devices": [{
            "id": "1234",
            "type": "Sensor",
            "price": 20,
            "currency": "USD",
            "isFavorite": false,
            "imageUrl": "",
            "title": "Test Sensor",
            "description": ""
        },
        {
            "id": "1235",
            "type": "Thermostat",
            "price": 25,
            "currency": "USD",
            "isFavorite": false,
            "imageUrl": "",
            "title": "Test Thermostat",
            "description": ""
        },
        {
            "id": "1235",
            "type": "Thermostat",
            "price": 25,
            "currency": "USD",
            "isFavorite": false,
            "imageUrl": "",
            "title": "Test Thermostat",
            "description": ""
        },
        {
            "id": "1235",
            "type": "Thermostat",
            "price": 25,
            "currency": "USD",
            "isFavorite": false,
            "imageUrl": "",
            "title": "Test Thermostat",
            "description": ""
        },
        {
            "id": "1235",
            "type": "Thermostat",
            "price": 25,
            "currency": "USD",
            "isFavorite": false,
            "imageUrl": "",
            "title": "Test Thermostat",
            "description": ""
        },
        {
            "id": "1235",
            "type": "Thermostat",
            "price": 25,
            "currency": "USD",
            "isFavorite": false,
            "imageUrl": "",
            "title": "Test Thermostat",
            "description": ""
        },
        {
            "id": "1235",
            "type": "Thermostat",
            "price": 25,
            "currency": "USD",
            "isFavorite": false,
            "imageUrl": "",
            "title": "Test Thermostat",
            "description": ""
        },
        {
            "id": "1235",
            "type": "Thermostat",
            "price": 25,
            "currency": "USD",
            "isFavorite": false,
            "imageUrl": "",
            "title": "Test Thermostat",
            "description": ""
        },
        {
            "id": "1235",
            "type": "Thermostat",
            "price": 25,
            "currency": "USD",
            "isFavorite": false,
            "imageUrl": "",
            "title": "Test Thermostat",
            "description": ""
        },
        {
            "id": "1235",
            "type": "Thermostat",
            "price": 25,
            "currency": "USD",
            "isFavorite": false,
            "imageUrl": "",
            "title": "Test Thermostat",
            "description": ""
        },
        {
            "id": "1235",
            "type": "Thermostat",
            "price": 25,
            "currency": "USD",
            "isFavorite": false,
            "imageUrl": "",
            "title": "Test Thermostat",
            "description": ""
        },
        {
            "id": "1235",
            "type": "Thermostat",
            "price": 25,
            "currency": "USD",
            "isFavorite": false,
            "imageUrl": "",
            "title": "Test Thermostat",
            "description": ""
        },
        {
            "id": "1235",
            "type": "Thermostat",
            "price": 25,
            "currency": "USD",
            "isFavorite": false,
            "imageUrl": "",
            "title": "Test Thermostat",
            "description": ""
        }
    ]
}
""".data(using: .utf8)!
