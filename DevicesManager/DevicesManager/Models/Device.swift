//
//  Device.swift
//  DevicesManager
//
//  Created by Sharun Garg on 2022-04-25.
//

import Foundation

struct Device: Codable {
    let id: String
    let type: String
    let price: Int
    let currency: String
    let imageUrl: String
    let title: String
    let description: String
}
