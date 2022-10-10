//
//  TootBootItem.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-10-10.
//

import Foundation

import Foundation

class TootBootItem: Codable, Hashable {
    
    let imageName: String
    let TootOrBoot: Bool //True = Toot, False = Boot
    let Queen: String
    let Critique: String
    let isNew: Bool
    
    static func == (lhs: TootBootItem, rhs: TootBootItem) -> Bool {
        return lhs.imageName == rhs.imageName && lhs.TootOrBoot == rhs.TootOrBoot && lhs.Queen == rhs.Queen && lhs.Critique == rhs.Critique && lhs.isNew == rhs.isNew
    }
    
}
