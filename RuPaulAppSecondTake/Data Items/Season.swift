//
//  Season.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-09-30.
//

import Foundation

enum Section {
    case main
}

struct Season: Codable, Hashable {
    var id: Int
    var seasonNumber: String
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case seasonNumber
        case image = "image_url"
    }
}
