//
//  Helper.swift
//  iTunesSearch
//
//  Created by Lloyd Dapaah on 6/16/18.
//  Copyright © 2018 Caleb Hicks. All rights reserved.
//

import Foundation
import UIKit

struct ItemController {
    
    static func fetchData(with query: [String:String], completion: @escaping (storeItems?) -> Void ) {
        let base = URL(string: "https://itunes.apple.com/search?")
        guard let url = base?.withQueries(query) else {
            print("Query could not be created")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, resp, err) in
            let decoder = JSONDecoder()
            
            //        if let data = data, let stringExtract = String(data: data, encoding: .utf8) {
            //            print(stringExtract)
            //        }
            
            if let data = data,
                let extract = try? decoder.decode(storeItems.self, from: data) {
                completion(extract)
            } else {
                print("Could not decode data to custom type")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    static func fetchData(with url: URL?, completion: @escaping (UIImage?) -> Void ) {
        guard let url = url else {
            print("Could not parse url")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let data = data,
                let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Could not parse image")
                completion(nil)
            }
        }
        
        task.resume()
    }
}

