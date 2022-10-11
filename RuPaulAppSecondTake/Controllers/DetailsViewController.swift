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
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var critiques: UITextView!
    
    //MARK: - Properties
    var item: TootBootItem?
    
    //MARK: - Load Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subject.delegate = self
        critiques.delegate = self

        if let item = item {
            subject.text = item.Queen
            critiques.text = item.Critique
            image.image = item.fetchImage(withIdentifier: item.imageName)
        }
        // Do any additional setup after loading the view.
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
