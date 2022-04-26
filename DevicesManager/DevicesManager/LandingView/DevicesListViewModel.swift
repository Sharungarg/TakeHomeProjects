//
//  DevicesListViewModel.swift
//  DevicesManager
//
//  Created by Sharun Garg on 2022-04-25.
//

import Foundation

fileprivate struct DevicesJSON: Codable {
    let devices: [Device]
}

protocol DevicesListViewModelDelegate {
    func fetchDevicesList(completion: @escaping ([Device])->())
}

struct DevicesListViewModel: DevicesListViewModelDelegate {
    private enum URLList {
        static let fetchDevicesURL: URL? = nil
    }
    
    func fetchDevicesList(completion: @escaping ([Device])->()) {
        RequestManager.shared.request(url: URLList.fetchDevicesURL, forData: DevicesJSON.self) { result in
            switch result {
            case .success(let result):
                completion(result.devices)
            case .failure(let error):
                print(error)
            }
        }
    }
}
