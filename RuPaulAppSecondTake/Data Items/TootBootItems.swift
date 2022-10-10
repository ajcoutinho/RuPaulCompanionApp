//
//  TootBootItems.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-10-10.
//

import Foundation
import UIKit

class TootBootItems: Codable {
    
    var itemsList = [TootBootItem]()
    
    var documentLibrary: URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        print(paths[0])
        
        return paths[0]
    }
    
    func addItem(item: TootBootItem) {
        itemsList.append(item)
        
        saveItems()
    }
    
    func removeItem(item: TootBootItem){
        for(index, tootBoot) in itemsList.enumerated(){
            if tootBoot == item {
                itemsList.remove(at: index)
                let imageName = tootBoot.imageName
                deleteImage(withIdentifier: imageName)
            }
        }
        saveItems()
    }
    
    func saveItems() {
        if let fileLocation =
            documentLibrary?.appendingPathComponent("items.json"){
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                
                let jsonData = try encoder.encode(itemsList)
                
                try jsonData.write(to: fileLocation)
            } catch {
                print("Error - Could not save: \(error.localizedDescription)")
            }
        }
    }
    
    func loadItems(){
        if let fileLocation = documentLibrary?.appendingPathComponent("items.json"){
            do{
                let jsonData = try Data(contentsOf: fileLocation)
                
                let decoder = JSONDecoder()
                itemsList = try decoder.decode([TootBootItem].self, from: jsonData)
            }catch {
                print("Unable to load the JSON - \(error.localizedDescription)")
            }
        }
    }
    
    func fetchImage(withIdentifier id: String)-> UIImage?{
        if let imagePath = documentLibrary?.appendingPathComponent(id), let imageFromDisk = UIImage(contentsOfFile: imagePath.path){
            return imageFromDisk
        }
        return nil
    }
    
    func saveImage(image: UIImage, withIdentifier id: String){
        if let imagePath = documentLibrary?.appendingPathComponent(id){
            if let data = image.jpegData(compressionQuality: 0.8){
                do {
                    try data.write(to: imagePath)
                } catch {
                    print("Error saving the image - \(error.localizedDescription)")
                }
            }
        }
    }
    
    func deleteImage(withIdentifier id: String){
        if let imagePath = documentLibrary?.appendingPathComponent(id){
            do{
                try FileManager.default.removeItem(at: imagePath)
            } catch {
                print("Error could not delete image - \(error.localizedDescription)")
            }
        }
    }
    
}
