//
//  Challenge.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-09-30.
//

import Foundation

struct Challenge: Codable, Hashable {
    
    var id: Int
    var type: String
    var description: String
    var queens: [Queen]
    
    //keys from reading from single episode
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case description
        case queens
    }
}
