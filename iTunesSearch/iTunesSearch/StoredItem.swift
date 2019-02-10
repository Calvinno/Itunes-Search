//
//  StoredItem.swift
//  iTunesSearch
//
//  Created by Calvin Cantin on 2019-02-09.
//  Copyright © 2019 Caleb Hicks. All rights reserved.
//

import Foundation

struct StoreItem: Codable {
    var name: String
    var artist: String
    var kind: String
    var description: String
    var artworkURL: URL
    
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case artist = "artistName"
        case kind
        case description
        case artworkURL = "artworkUrl100"
    }
    
    enum AdditionalKeys: String, CodingKey {
        case longDescription
    }
    
    init(from decoder: Decoder) throws {
        let valuesContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try valuesContainer.decode(String.self, forKey: CodingKeys.name)
        self.artist = try valuesContainer.decode(String.self, forKey: CodingKeys.artist)
        self.kind = try valuesContainer.decode(String.self, forKey: CodingKeys.kind)
        self.artworkURL = try valuesContainer.decode(URL.self, forKey: CodingKeys.artworkURL)
        if let description = try? valuesContainer.decode(String.self, forKey: CodingKeys.description) {
            self.description = description
        } else {
            let additionalValuesContainter = try decoder.container(keyedBy: AdditionalKeys.self)
            self.description = (try? additionalValuesContainter.decode(String.self, forKey: AdditionalKeys.longDescription)) ?? ""
        }
    }
}

struct StoreItems: Codable {
    let results: [StoreItem]
}
