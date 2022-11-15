//
//  ViewController.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-09-29.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(displayInfo))
    }

    
    @objc func displayInfo() {
        let alert = UIAlertController(title: "Welcome to the RuPaul Companion!", message: "Select one of the tabs to get started. If you don't know what to do, tap the info button on any page to recieve instructions.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .default))
        
        present(alert, animated: true)
    }
    
}

