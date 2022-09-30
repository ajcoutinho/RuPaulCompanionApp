//
//  Queen.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-09-30.
//

import Foundation

struct Queen: Codable, Hashable {
    
    var id: Int
    var name: String
    var image: String?
    
    //key from reading from queen objects.
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image = "image_url"
    }
    
}
