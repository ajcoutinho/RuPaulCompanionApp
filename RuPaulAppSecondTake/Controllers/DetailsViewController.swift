//
//  DetailsViewController.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-10-10.
//

import UIKit

class DetailsViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tootBoot: UIImageView!
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var critiques: UITextView!
    
    //MARK: - Properties
    var item: TootBootItem?
    var items: TootBootItems!
    
    //MARK: - Load Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subject.delegate = self
        critiques.delegate = self

        if let item = item {
            subject.text = item.Queen
            critiques.text = item.Critique
            if item.TootOrBoot {
                tootBoot.image = UIImage(named: "TootButton")
            } else {
                tootBoot.image = UIImage(named: "BootButton")
            }
            
            let imageTapped = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            imageTapped.delegate = self
            tootBoot.addGestureRecognizer(imageTapped)
            
            image.image = item.fetchImage(withIdentifier: item.imageName)
            
            item.isNew = false
            
            items.saveItems()
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func imageTapped() {
        if let item = item {
            item.TootOrBoot.toggle()
            if item.TootOrBoot {
                tootBoot.image = UIImage(named: "TootButton")
            } else {
                tootBoot.image = UIImage(named: "BootButton")
            }
            items.saveItems()
        }
    }

}

//MARK: - Extensions

extension DetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        subject.resignFirstResponder()
        return true
    }
}

extension DetailsViewController: UITextViewDelegate {
    
}

extension DetailsViewController: UIGestureRecognizerDelegate {
    
}
