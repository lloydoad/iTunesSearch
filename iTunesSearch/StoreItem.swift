//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by Lloyd Dapaah on 6/16/18.
//  Copyright © 2018 Caleb Hicks. All rights reserved.
//

import Foundation

struct storeItem: Codable{
    // general information
    var itemTitle: String
    var itemAuthor: String
    var kind: String?
    
    // have alternating keys
    var artworkUrl: URL?
    var price: Double?
    
    // music information
    var albumTitle: String?
    var previewUrl: URL?
    
    // app, book, movie information
    var description: String?
    
    enum GeneralCodingKeys: String, CodingKey {
        case itemTitle = "trackName"
        case itemAuthor = "artistName"
        case kind
    }
    
    enum alternatingCodingKeys: String, CodingKey {
        case artworkUrl512
        case artworkUrl100
        case artworkUrl60
        case artworkUrl30
        
        case trackPrice
        case price
    }
    
    enum extraCodingKeys: String, CodingKey {
        case collectionName
        case descriptionName
        case longDescription
        case previewUrl
    }
    
    init(from decoder: Decoder) throws {
        let generalContainer = try decoder.container(keyedBy: GeneralCodingKeys.self)
        self.itemTitle = try generalContainer.decode(String.self, forKey: .itemTitle)
        self.itemAuthor = try generalContainer.decode(String.self, forKey: .itemAuthor)
        self.kind = try? generalContainer.decode(String.self, forKey: .kind)
        
        let altContainer = try decoder.container(keyedBy: alternatingCodingKeys.self)
        if let artwork = try? altContainer.decode(URL.self, forKey: .artworkUrl512) {
            self.artworkUrl = artwork
        } else if let artwork = try? altContainer.decode(URL.self, forKey: .artworkUrl100) {
            self.artworkUrl = artwork
        } else if let artwork = try? altContainer.decode(URL.self, forKey: .artworkUrl60) {
            self.artworkUrl = artwork
        } else if let artwork = try? altContainer.decode(URL.self, forKey: .artworkUrl30) {
            self.artworkUrl = artwork
        }
        if let price = try? altContainer.decode(Double.self, forKey: .trackPrice) {
            self.price = price
        } else if let price = try? altContainer.decode(Double.self, forKey: .price){
            self.price = price
        }
        
        let extraContainer = try decoder.container(keyedBy: extraCodingKeys.self)
        self.albumTitle = try? extraContainer.decode(String.self, forKey: .collectionName)
        if let desc = try? extraContainer.decode(String.self, forKey: .descriptionName) {
            self.description = desc
        } else if let desc = try? extraContainer.decode(String.self, forKey: .longDescription) {
            self.description = desc
        }
        self.previewUrl = try? extraContainer.decode(URL.self, forKey: .previewUrl)
    }
}

struct storeItems: Codable {
    var resultCount: Int
    var results: [storeItem]
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCount.self = try container.decode(Int.self, forKey: .resultCount)
        results.self = try container.decode([storeItem].self, forKey: .results)
    }
}



