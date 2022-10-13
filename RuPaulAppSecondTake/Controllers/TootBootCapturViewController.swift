//
//  TootBootCapturViewController.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-10-06.
//

import UIKit

class TootBootCapturViewController: UIViewController, UIGestureRecognizerDelegate{

    var itemsList: TootBootItems!
    
    //MARK: - Outlets
    @IBOutlet weak var TootBootCaptureImage: UIImageView!
    
    
    //MARK: - Load Method
    override func viewDidLoad() {
        super.viewDidLoad()

        //set the gesture reconizers in the photo view
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(viewSwipedLeft))
        swipeLeft.direction = .left
        TootBootCaptureImage.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(viewSwipedRight))
        swipeRight.direction = .right
        TootBootCaptureImage.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(viewSwipedDown))
        swipeDown.direction = .down
        TootBootCaptureImage.addGestureRecognizer(swipeDown)
        
        let alert = UIAlertController()
        alert.title = "Ready to take a photo?"
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            //Add action to go to gallery
        }))
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        var isFinished = false
        while !isFinished {
            present(imagePicker, animated: true)
            
            let newAlert = UIAlertController(title: "Would you like to take another?", message: nil, preferredStyle: .alert)
            newAlert.addAction(UIAlertAction(title: "Yes", style: .default))
            newAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (_) in
                isFinished = true
            }))
        }
        
        
    }
    
    
    //MARK: - Obj-C Methods
    @objc func viewSwipedLeft() {
        //Saves an item to the gallery list, with the TootBoot set to 'true'
        if let image = TootBootCaptureImage.image {
            let imageName = UUID().uuidString
            let newItem = TootBootItem(photo: imageName, TootBoot: true)
            itemsList.saveImage(image: image, withIdentifier: imageName)
            itemsList.addItem(item: newItem)
        }
    }
    
    @objc func viewSwipedRight() {
        //Saves an item to the gallery list, with the TootBoot set to 'false'
        if let image = TootBootCaptureImage.image {
            let imageName = UUID().uuidString
            let newItem = TootBootItem(photo: imageName, TootBoot: false)
            itemsList.saveImage(image: image, withIdentifier: imageName)
            itemsList.addItem(item: newItem)
        }
    }
    
    @objc func viewSwipedDown() {
        //Discards the image, and allows for another to be taken.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TootBootCapturViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        TootBootCaptureImage.image = image
        
        navigationController?.dismiss(animated: true)
    }
    
}
