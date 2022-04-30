//
//  Character.swift
//  RickAndMorty
//
//  Created by Sharun Garg on 2022-04-23.
//

import Foundation

struct Character: Codable {
    let id: Int
    let image: String
    let name: String
    let status: String
    let species: String
    let gender: String
    let episode: [String]
    let location: Location
}
