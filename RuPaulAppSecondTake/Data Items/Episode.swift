//
//  Episode.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-09-30.
//

import Foundation

struct Episode: Codable, Hashable {
    
    var id: Int
    var title: String
    var episodeInSeason: Int
    var seasonId: Int
    var airDate: String
    
    //Keys for reading from episode
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case episodeInSeason
        case seasonId
        case airDate
    }
    
}

