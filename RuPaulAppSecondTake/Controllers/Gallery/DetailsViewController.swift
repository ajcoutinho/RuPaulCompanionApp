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
            subject.text = item.subject
            critiques.text = item.critique
            if item.tootOrBoot {
                tootBoot.image = UIImage(named: "TootButton")
            } else {
                tootBoot.image = UIImage(named: "BootButton")
            }
            
            let imageTapped = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            imageTapped.delegate = self
            tootBoot.addGestureRecognizer(imageTapped)
            
            image.image = items.fetchImage(withIdentifier: item.imageName)
            
            item.isNew = false
            
            items.saveItems()
        }
    }
    
    //MARK: Objective-C Methods
    @objc func imageTapped() {
        if let item = item {
            item.tootOrBoot.toggle()
            if item.tootOrBoot {
                tootBoot.image = UIImage(named: "TootButton")
            } else {
                tootBoot.image = UIImage(named: "BootButton")
            }
            items.saveItems()
        }
    }
    
    
    //MARK: - Actions
    @IBAction func saveInfo(_ sender: Any) {
        
        if let item = item {
            item.subject = subject.text
            item.critique = critiques.text
            items.saveItems()
            
            let alert = UIAlertController(title: "Info saved!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func deleteItem(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            if let item = self.item {
                self.items.deleteImage(withIdentifier: item.imageName)
                self.items.removeItem(item: item)
                
                let ac = UIAlertController(title: "Item deleted", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default) {
                    [weak self] _ in
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: true)
                    }
                })
                self.present(ac, animated: true)
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        present(alert, animated: true)
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
