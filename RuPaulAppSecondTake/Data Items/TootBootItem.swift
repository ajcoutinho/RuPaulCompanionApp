//
//  TootBootItem.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-10-10.
//

import Foundation
import UIKit

class TootBootItem: Codable, Hashable {
    
    //MARK: - Properties
    var imageName: String
    var tootOrBoot: Bool //True = Toot, False = Boot
    var subject: String?
    var critique: String?
    var isNew: Bool
    
    //MARK: - Methods
    init(photo: String, TootBoot: Bool) {
        self.imageName = photo
        self.tootOrBoot = TootBoot
        self.isNew = true
    }
    
    static func == (lhs: TootBootItem, rhs: TootBootItem) -> Bool {
        return lhs.imageName == rhs.imageName && lhs.tootOrBoot == rhs.tootOrBoot && lhs.subject == rhs.subject && lhs.critique == rhs.critique && lhs.isNew == rhs.isNew
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(imageName)
        hasher.combine(tootOrBoot)
        hasher.combine(subject)
        hasher.combine(critique)
        hasher.combine(isNew)
    }
    
}
