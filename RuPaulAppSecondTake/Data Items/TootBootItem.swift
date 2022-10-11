//
//  TootBootItem.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-10-10.
//

import Foundation
import UIKit

class TootBootItem: Codable, Hashable {
    
    let imageName: String
    let TootOrBoot: Bool //True = Toot, False = Boot
    let Queen: String
    let Critique: String
    let isNew: Bool
    
    var documentLibrary: URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        print(paths[0])
        
        return paths[0]
    }
    
    static func == (lhs: TootBootItem, rhs: TootBootItem) -> Bool {
        return lhs.imageName == rhs.imageName && lhs.TootOrBoot == rhs.TootOrBoot && lhs.Queen == rhs.Queen && lhs.Critique == rhs.Critique && lhs.isNew == rhs.isNew
    }
    
    func fetchImage(withIdentifier id: String)-> UIImage?{
        if let imagePath = documentLibrary?.appendingPathComponent(id), let imageFromDisk = UIImage(contentsOfFile: imagePath.path){
            return imageFromDisk
        }
        return nil
    }
    
}
