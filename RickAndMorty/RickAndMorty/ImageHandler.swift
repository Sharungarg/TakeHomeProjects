//
//  ImageHandler.swift
//  RickAndMorty
//
//  Created by Sharun Garg on 2022-04-28.
//

import Foundation
import UIKit

class ImageHandler {
    
    static let shared: ImageHandler = ImageHandler()
    
    private init() {}
    
    private let imageCache = NSCache<NSString, NSData>()
    
    func getImage(forURL imageURL: String, completion: @escaping (UIImage?)->()) {
        
        if let cachedImageData = imageCache.object(forKey: imageURL as NSString) as? Data {
            print("using image cache")
            DispatchQueue.main.async {
                completion(UIImage(data: cachedImageData))
            }
            return
        }
        
        guard let validURL = URL(string: imageURL) else { return }
        
        RequestManager.shared.request(with: validURL, forData: Data.self) { [weak self] result in
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    print("downloading image")
                    self?.imageCache.setObject(imageData as NSData, forKey: imageURL as NSString)
                    completion(UIImage(data: imageData))
                }
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
