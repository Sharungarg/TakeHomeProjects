//
//  CharacterTableViewModel.swift
//  RickAndMorty
//
//  Created by Sharun Garg on 2022-04-27.
//

import Foundation

protocol CharacterTableViewModelProtocol {
    func fetchCharacters(completion: @escaping ([Character]?) -> ())
}

fileprivate struct CharacterResponse: Codable {
    let results: [Character]
}

struct CharacterTableViewModel: CharacterTableViewModelProtocol {
    
    private enum URLs {
        static let fetchCharacter = URL(string: "https://rickandmortyapi.com/api/character")!
    }
    
    func fetchCharacters(completion: @escaping ([Character]?) -> ()) {
        RequestManager.shared.request(with: URLs.fetchCharacter, forData: CharacterResponse.self) { apiResponse in
            switch apiResponse {
            case .success(let characterResponse):
                completion(characterResponse.results)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}

